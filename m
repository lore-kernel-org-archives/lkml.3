Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3ATLTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:19:25 -0500
Received: from 8bytes.org ([85.214.48.195]:40949 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab3ATLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:19:24 -0500
Date: Sun, 20 Jan 2013 12:19:20 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130120111920.GL25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FBC994.8020409@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan 20 12:19:20 2013
X-DSPAM-Confidence: 0.9976
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fbd2b822971665154718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 11:40:20AM +0100, Udo van den Heuvel wrote:
> Hello,
> 
> On 2013-01-20 11:36, Borislav Petkov wrote:
> > I know just the guy, CCed. :-)
> 
> Thanks for the quick response!
> I found this similar case:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073384

Yes, this is a Hardware issue for which the BIOS does not apply the
workaround. The only solution for now is to disable the IOMMU on the
Trinity based chips. Unfortunatly I don't have access to the hardware
any longer to write a workaround in the AMD IOMMU driver.

The question is what to do now, I tend to disable the IOMMU if a
Trinity chip is detected. This is not the first report of this problem
I encountered.


Regards,

	Joerg


