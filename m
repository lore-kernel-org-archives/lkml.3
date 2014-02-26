Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBZN0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:26:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:54179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaBZN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:26:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 4/5] bug: Use a common definition of BUG_ON regardless of CONFIG_BUG
Date: Wed, 26 Feb 2014 14:26:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <6ce38c3701f8ed1d30bfc1661ede7eade46a79c6.1393385236.git.josh@joshtriplett.org>
In-Reply-To: <6ce38c3701f8ed1d30bfc1661ede7eade46a79c6.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261426.37800.arnd@arndb.de>
X-Provags-ID: V02:K0:EzaBHJWg9oZi0V4+Q7N/3pCAcUeW26kyEZkQ6j24GaS
 lmG/1WX6VE9cTOFk8wkTX4z+/TegNHfb9SyhXzEczh7YKySrpP
 p2usrlZYDI45w9rBj5stM5bxvEjPgYSPR2InOVhkkOQ6gJ2ThH
 DCi6vGWbdL/pmAepfnldCSDWq1mPiTFSZmVb0sAIH7R46j5mz2
 UtL+LFxIs99glFE727UmrWTtJ1vyXb+sNiw4bx6uvTV1ADVs61
 O7hbDxmOVQZQsb0YOOnB66rciVsTCn+seaF9ONOTvnUnQTJJxz
 NvzgWV2D5sQdlV/djPT793/UlHy6PV6jQPnBJesObe57R3E6RY
 BqcBOnO+7V4KsmiQytWc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Josh Triplett wrote:
> 
> include/asm-generic/bug.h defines BUG_ON to call BUG() if CONFIG_BUG=y,
> or as a no-op if !CONFIG_BUG.  However, BUG() is already a no-op if
> !CONFIG_BUG, making this pointless.  Use a common definition that always
> calls BUG().
> 
> This does not change the compiled code at all.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
