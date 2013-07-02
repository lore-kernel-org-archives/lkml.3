Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3GBWbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:31:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40443 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab3GBWbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:31:09 -0400
From: "Etheridge, Darren" <detheridge@ti.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
Thread-Topic: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
Thread-Index: AQHOcmHdKs7rDvXue0aMGNA3Mp9lmplIN4sAgAABDACAAAHFAIAAAScAgAk9EICAAIh0MA==
Date: Tue, 2 Jul 2013 22:31:04 +0000
Message-ID: <1A80A2FD7F34484786E5DF71F3968B6940F0D587@DLEE10.ent.ti.com>
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com>
 <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com>
 <51CAD305.30407@ti.com>
 <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com>
 <51CAD7E4.2000403@ti.com>
 <CA+V-a8u6vjSc5EV3z4FCQ8LEHxL79bUXtHzX8svhQwqVtj6w=g@mail.gmail.com>
 <51CADA58.2030602@ti.com>
 <CA+V-a8vij-4s1FsePmSZrdUTBZJPWZV6Wq9s=uurOHh2k47JNA@mail.gmail.com>
In-Reply-To: <CA+V-a8vij-4s1FsePmSZrdUTBZJPWZV6Wq9s=uurOHh2k47JNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> How do you suggest to handle it ?
> >
> > I think it's easiest if Darren handles the da8xx-fb series for 3.11.
> > So if there's something missing from Darren's series, please discuss
> with him.
> >
> Either you merge this patch with yours or rebase your patch on top of
> my patch.
> Let me know how you would like to handle it ?
Prabhakar,

I will include your change with the next version of this patch series that will address Tomi's review comments.  

Darren
