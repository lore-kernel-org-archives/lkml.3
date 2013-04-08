Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab3DHStN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:49:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935215Ab3DHStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:49:11 -0400
Date: Mon, 8 Apr 2013 20:48:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130408184836.GI4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
	"iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
 <02D2024799561B48A732D1A51CB969E81959AF3E@sausexdag04.amd.com>
 <20130408145003.GC4723@pd.tnic>
 <5162E5B1.2030707@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5162E5B1.2030707@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:43:45AM -0500, Suravee Suthikulanit wrote:
> On 4/8/2013 9:50 AM, Borislav Petkov wrote:
> >Independent from Joerg's feedback on this, I have only one question:
> >you're not seriously considering on dumping this "Note:..." line above
> >on*every*  IO-PF, right?
> If you think that is obvious, I can get rid of this also.

I don't know whether it is obvious or not, but this thing doesn't belong
there. I'm sure you can think of a much better fitting location to point
to the documentation. And while you do that, you can simply add a link
to the pdf version of the spec so that people don't have to look for it
at all.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
