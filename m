Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbbAPUKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:10:11 -0500
Received: from skprod3.natinst.com ([130.164.80.24]:44178 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753094AbbAPUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:10:09 -0500
Message-ID: <54B97012.4050402@ni.com>
Date: Fri, 16 Jan 2015 14:09:54 -0600
From: Xander Huff <xander.huff@ni.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Vick, Matthew" <matthew.vick@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Williams, Mitch A" <mitch.a.williams@intel.com>
CC: Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeff.westfahl@ni.com" <jeff.westfahl@ni.com>,
        "Fujinaka, Todd" <todd.fujinaka@intel.com>
Subject: Re: [PATCH RESEND] igb: Reset TXPBSIZE to default value
References: <1421434779-20586-1-git-send-email-xander.huff@ni.com> <D0DEA929.671EB%matthew.vick@intel.com>
In-Reply-To: <D0DEA929.671EB%matthew.vick@intel.com>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/16/2015 02:09:54 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/16/2015 02:09:55 PM,
	Serialize complete at 01/16/2015 02:09:55 PM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252; format=flowed
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-16_07:2015-01-16,2015-01-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2015 1:41 PM, Vick, Matthew wrote:
> On 1/16/15, 10:59 AM, "Xander Huff" <xander.huff@ni.com> wrote:
>
>> From: Jeff Westfahl <jeff.westfahl@ni.com>
>>
>> The TXPBSIZE register of the i210 resets to its default value only
>> at power-on. It doesn't reset if you reboot the system, only if you
>> pull power. If something (another driver, another OS, etc.) modifies
>> this register from its default value, the igb driver doesn't function
>> correctly. It detects a hang of the transmitter and continuously resets
>> the adapter. Here we set this value to its default when resetting the
>> i210 to resolve this issue.
>
> This should have already been resolved last May in commit
> 27dff8b2f680ce966b5d959be9d69dd0edd92e3b ("igb: add defaults for i210
> TX/RX PBSIZE"). Are you running the latest upstream kernel?
>
> Cheers,
> Matthew
>
Looks like you're correct. Please disregard this patch.

-- 
Xander Huff
Staff Software Engineer
National Instruments
