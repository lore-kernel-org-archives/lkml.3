Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3GWL7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:59:32 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:2215 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3GWL7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:59:31 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 07:59:31 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwFAAht7lGQ/khM/2dsb2JhbABbgwaDR713gRAWdIIkAQEFeRALFQMuITYGE4d+Aw+wDQ2IXo0ogmsHg34DiHCNBIFpjCeFJoMUOg
X-IronPort-AV: E=Sophos;i="4.89,727,1367971200"; 
   d="scan'208";a="157381677"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 0/5] Davinci VPBE use devres and some cleanup
Date: Tue, 23 Jul 2013 13:49:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-0.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LMML <linux-media@vger.kernel.org>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8ue48_p1ysK+H3i5i_P29KTESxX2U-SU1frcyvGRLn8wQ@mail.gmail.com>
In-Reply-To: <CA+V-a8ue48_p1ysK+H3i5i_P29KTESxX2U-SU1frcyvGRLn8wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307231349.31264.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23 July 2013 13:17:43 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Sat, Jul 13, 2013 at 2:20 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
> > From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >
> > This patch series replaces existing resource handling in the
> > driver with managed device resource.
> >
> > Lad, Prabhakar (5):
> >   media: davinci: vpbe_venc: convert to devm_* api
> >   media: davinci: vpbe_osd: convert to devm_* api
> >   media: davinci: vpbe_display: convert to devm* api
> >   media: davinci: vpss: convert to devm* api
> 
> can you pick up patches 1-4 for 3.12 ? I'll handle the 5/5 patch later.

Will do. I'm planning on a new pull request during/around the weekend.

Regards,

	Hans
