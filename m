Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3HCVab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 17:30:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54220 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3HCVaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 17:30:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Sat, 03 Aug 2013 23:40:40 +0200
Message-ID: <2483450.yz2brWbP8X@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s1SobAmSwth+=-pHYN77u-yEumqMfes1w3Bj-8sLTpWng@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <13505759.IqzsRNCUnN@vostro.rjw.lan> <CAMP44s1SobAmSwth+=-pHYN77u-yEumqMfes1w3Bj-8sLTpWng@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 03:24:16 PM Felipe Contreras wrote:
> On Sat, Aug 3, 2013 at 6:34 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
> 
> >> Yes, the patch is correct, but I still prefer my own version :-)
> >> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
> >>
> >> In case you want to take mine and mine needs refresh, please let me know
> >> and I can do the re-base, thanks.
> >
> > Well, I prefer simpler, unless there's a good reason to use more complicated.
> 
> Note that these are not exclusionary; his patch can be applied on top
> of mine. I don't think his patch is needed though.

OK

Do we still need to revert commit efaa14c if this patch is applied?

Rafael

