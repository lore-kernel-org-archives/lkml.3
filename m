Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbbAAUL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:11:59 -0500
Received: from www.xora.org.uk ([80.68.91.202]:33464 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAAUL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:11:58 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2015 15:11:57 EST
Date: Thu, 1 Jan 2015 20:04:24 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: ashwinc@codeaurora.org, catalin.marinas@arm.com, rjw@rjwysocki.net,
        mark.rutland@arm.com, olof@lixom.net, grant.likely@linaro.org,
        will.deacon@arm.com, linaro-acpi@lists.linaro.org, Liviu.Dudau@arm.com,
        lv.zheng@intel.com, robh@kernel.org, Lorenzo.Pieralisi@arm.com,
        al.stone@linaro.org, daniel.lezcano@linaro.org, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, Charles.Garcia-Tobin@arm.com,
        rric@kernel.org, jason@lakedaemon.net, arnd@arndb.de,
        marc.zyngier@arm.com, jcm@redhat.com, broonie@kernel.org,
        "bhelgaas@google.com." <linux-arm-kernel@lists.infradead.org>,
        graeme.gregory@linaro.org, Kangkang.Shen@huawei.com,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        Sudeep.Holla@arm.com
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150101200424.GB12770@xora-haswell.xora.org.uk>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org>
 <CAJ5Y-eZ5cu9_OhG24yAv+CZq7zKg0vU+eVGekyN+9dDzaz1OhQ@mail.gmail.com>
 <8fc9550c96a468b3e50d51a37db68a33.squirrel@www.codeaurora.org>
 <54A3B526.9040903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54A3B526.9040903@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 04:34:46PM +0800, Hanjun Guo wrote:
> On 2014年12月31日 04:13, ashwinc@codeaurora.org wrote:
> >Hi Hanjun,
> >
> >Overall the document looks good to us. Some minor clarifications below.
> >
> >>---------- Forwarded message ----------
> >>From: Graeme Gregory <graeme.gregory@linaro.org>
> >>
> >>Add documentation for the guidelines of how to use ACPI
> >>on ARM64.
> >>
> >>Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> >>Signed-off-by: Al Stone <al.stone@linaro.org>
> >>Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >>---
> >>  Documentation/arm64/arm-acpi.txt |  323
> >>++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 323 insertions(+)
> >>  create mode 100644 Documentation/arm64/arm-acpi.txt
> >>
> >
> >[..]
> >
> >>+Relationship with Device Tree
> >>+-----------------------------
> >
> >[..]
> >
> >>+When booting using ACPI tables, the /chosen node in DT will still be
> >>parsed
> >>+to extract the kernel command line and initrd path.  No other section of
> >>the
> >>+DT will be used.
> >
> >Is this still true?
> 
> No, we can booting the ACPI system in EFI stub without dtb. Catalin
> also pointed out this issue, I will remove this paragraph.
> 

The paragraph is still correct, the /chosen node is always present even
if nothing else is.

Graeme

