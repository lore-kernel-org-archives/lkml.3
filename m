Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaBZNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:25:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:57164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaBZNZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:25:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 3/5] bug: When !CONFIG_BUG, make WARN call no_printk to check format and args
Date: Wed, 26 Feb 2014 14:25:49 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org> <770b3955bdcec63564ae09741ae154f8908c22c6.1393385236.git.josh@joshtriplett.org>
In-Reply-To: <770b3955bdcec63564ae09741ae154f8908c22c6.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402261425.49779.arnd@arndb.de>
X-Provags-ID: V02:K0:gcNbYY0X8EmH5frCadb7CLB76rwVXYbOx++uKlFXDBU
 xGG1d+tT7L0zjqgflD8P4WMrSOCcBQMHU/6Jrb1dtaJ+3fHuVh
 ucmy4Z3TfVTtWsTGb+wLghC+Al8tAk5CaNd+Bv7ajYcXW4Hkb8
 9haYlgPd5EvRu7WIQwUIYOuPos7NzEMpOU7bhFzA5KJ571HQKv
 E6OSHx1kRdfHKvN3D464XtHqeux7yOOTF300SNduOWetqwAvu4
 k6Yj2LzzTw5ss8DEs3/MQjiLcxqYk4w/3KpGpGN7AIEGWtKuKu
 vDgZcp5K+9xrzqkCiJoXA9RXwkrP8UXKwK20xhpnKpHqlpQOtj
 j6WAQtrbR+DZVfFSq7NY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Josh Triplett wrote:
> The stub version of WARN for !CONFIG_BUG completely ignored its format
> string and subsequent arguments; make it check them instead, using
> no_printk.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
