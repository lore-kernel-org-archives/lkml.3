Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3AUPKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:10:05 -0500
Received: from 8bytes.org ([85.214.48.195]:42334 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3AUPKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:10:03 -0500
Date: Mon, 21 Jan 2013 16:10:00 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, Udo van den Heuvel <udovdh@xs4all.nl>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121151000.GR25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
 <20130120115755.GO25591@8bytes.org>
 <20130121130942.GB4445@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121130942.GB4445@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 21 16:10:01 2013
X-DSPAM-Confidence: 0.9970
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fd5a4922971235695577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:09:42PM +0100, Borislav Petkov wrote:
> [    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> [    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> [    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)

Yes, that are BIOS bugs too that prevent interrupt remapping to function
reliably. But the good thing is that these bugs can be detected easily
to enable a workaround :-)


	Joerg


