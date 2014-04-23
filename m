Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaDWNcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:32:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbaDWNb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:31:56 -0400
Message-ID: <1398259914.32091.4.camel@linux-fkkt.site>
Subject: Re: [PATCH v2 01/24] input: Add ff-memless-next module
From: Oliver Neukum <oneukum@suse.de>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Date: Wed, 23 Apr 2014 15:31:54 +0200
In-Reply-To: <12060887.UbTEf5RVBB@sigyn>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
	 <1398175209-9565-2-git-send-email-madcatxster@devoid-pointer.net>
	 <1398255179.32091.1.camel@linux-fkkt.site> <12060887.UbTEf5RVBB@sigyn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 14:30 +0200, Michal Malý wrote:

> > 2. That is needlessly inefficient
> Are you suggesting I drop the 'consts' and keep the memory preallocated?

Yes.

	Regards
		Oliver


