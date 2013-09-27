Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3I0UUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:20:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab3I0UUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:20:00 -0400
Date: Fri, 27 Sep 2013 16:19:51 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
Message-ID: <20130927201951.GA22836@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130925001344.GA13554@redhat.com>
 <5245E7B1.2000408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245E7B1.2000408@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 03:16:49PM -0500, H. Peter Anvin wrote:
 > On 09/24/2013 07:13 PM, Dave Jones wrote:
 > > This seems to have been copied from the Optiplex 990 entry above, but somoene
 > > forgot to change the ident text.
 > > 
 > > Signed-off-by: Dave Jones <davej@fedoraproject.org>
 > > 
 > > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
 > > index f6835d8..ea2aaca 100644
 > > --- a/arch/x86/kernel/reboot.c
 > > +++ b/arch/x86/kernel/reboot.c
 > > @@ -360,7 +360,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 > >  	},
 > >  	{	/* Handle problems with rebooting on the Precision M6600. */
 > >  		.callback = set_pci_reboot,
 > > -		.ident = "Dell OptiPlex 990",
 > > +		.ident = "Dell Precision M6600",
 > >  		.matches = {
 > >  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 > >  			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 > > 
 > 
 > It really is starting to feel like *ALL* Dell machines need reboot=pci?

Either that or 'bios'.  The question I have is, of those marked 'bios', does =pci
work too ?  If we knew that was true, I'd probably say yes.

	Dave

