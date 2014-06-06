Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaFFHSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:18:25 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15548 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFFHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:18:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 06 Jun 2014 00:10:17 -0700
Message-ID: <53916B3B.5030400@nvidia.com>
Date: Fri, 6 Jun 2014 10:18:19 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <5390A8F9.2090408@wwwdotorg.org> <53915F3B.6050806@nvidia.com> <20140606071148.GC31915@ulmo>
In-Reply-To: <20140606071148.GC31915@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that might be the easiest. If you go that way, you should probably 
also add an #include for the XUSB binding include file.

- Mikko

On 06/06/14 10:11, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jun 06, 2014 at 09:27:07AM +0300, Mikko Perttunen wrote:
>> The only compile-time dependencies here should be that:
>> - patch 8 of 9 which contains the actual driver depends on patch 6 of 9
>> (though only when building as a module) and the efuse series
>> - patch 2 of 9 refers to the DT node called "padctl", so it requires the
>> xusb series. (in the submitted xusb series, the node isn't actually named,
>> though. I will fix this in v2)
>
> My intention was to add the label in the patch which first adds a
> reference to the device. In my tree that was the PCIe driver. Given that
> it's not clear yet in what order these will be merged, I'm thinking I
> should simply add that fragment in the patch that adds the node since we
> know that it will eventually be used.
>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>
