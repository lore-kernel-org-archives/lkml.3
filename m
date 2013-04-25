Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab3DYCH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 22:07:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33640 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932227Ab3DYCH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 22:07:26 -0400
Date: Wed, 24 Apr 2013 21:07:24 -0500
From: Robin Holt <holt@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.de>, DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, "holt@sgi.com" <holt@sgi.com>
Subject: Re: memcpy_fromio in dmi_scan.c
Message-ID: <20130425020724.GR3658@sgi.com>
References: <1366636689.4503.35.camel@chaos.site>
 <5175FF0F.9050206@oracle.com>
 <1366702122.4667.11.camel@chaos.site>
 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
 <1366831328.4618.476.camel@chaos.site>
 <3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 08:16:50PM +0000, Luck, Tony wrote:
> > That being said, "my" SN2 machine was previously running kernel 3.0.34
> > which has the old dmi_scan code and it also said "DMI not present or
> > invalid." Plus dmidecode fails on this machine with:
> >
> > /sys/firmware/efi/systab: SMBIOS entry point missing
> >
> > So it might as well be that DMI support on SN2 was already broken.
> > Please let me know your findings on other SN2 machines.
> 
> I don't have an sn2 to test. Added Robin Holt to Cc list

I will try and boot an sn2 machine first thing tomorrow morning.
I don't recall dmidecode being broken, but that was quite a while ago.
I thought the license validation code we used on sn2 used data from the
dmidecode output.

Robin
