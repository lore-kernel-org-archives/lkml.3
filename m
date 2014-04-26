Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaDZPFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:05:51 -0400
Received: from prifuk.cz ([31.31.77.140]:50070 "EHLO smtp.devoid-pointer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaDZPFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:05:46 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Antonio Ospite <ao2@ao2.it>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v3 16/24] hid: Port hid-sony to ff-memless-next
Date: Sat, 26 Apr 2014 17:05:39 +0200
Message-ID: <1761990.LZeFYxtATY@sigyn>
User-Agent: KMail/4.13 (Linux/3.14.1-1-my-rd; KDE/4.13.0; x86_64; ; )
In-Reply-To: <20140426150944.b119fd7f8c4334353b77d3d2@ao2.it>
References: <1398513696-12626-1-git-send-email-madcatxster@devoid-pointer.net> <1398513696-12626-17-git-send-email-madcatxster@devoid-pointer.net> <20140426150944.b119fd7f8c4334353b77d3d2@ao2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 of April 2014 15:09:44 Antonio Ospite wrote:
> On Sat, 26 Apr 2014 13:57:53 +0200
> 
> Michal Malý <madcatxster@devoid-pointer.net> wrote:
> > Port hid-sony to ff-memless-next
> > 
> > Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
> 
> Not a big deal, but note that the patch adds an unneeded
> blank line. Pointed out below.

Oh, thanks. Corrected in "v4".

