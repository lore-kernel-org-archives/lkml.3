Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBWExO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 23:53:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:22764 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbaBWExN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 23:53:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,527,1389772800"; 
   d="scan'208";a="480195943"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: Pasi K?rkk?inen <pasik@iki.fi>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>,
        Lars Kurth <lars.kurth@xenproject.org>
Subject: RE: [Xen-devel] [Announcement] Updates to XenGT - a Mediated
 Graphics Passthrough Solution from Intel
Thread-Topic: [Xen-devel] [Announcement] Updates to XenGT - a Mediated
 Graphics Passthrough Solution from Intel
Thread-Index: Ac8uCM+UTJUf7TAWTkKmKWKJu37vjgAHsPmAACDtz+AAOVsWgAAv5MIQ
Date: Sun, 23 Feb 2014 04:53:08 +0000
Message-ID: <A25F549E4D43CD42B4C02DF47A1913231105F908@SHSMSX103.ccr.corp.intel.com>
References: <A25F549E4D43CD42B4C02DF47A19132311058FC7@SHSMSX103.ccr.corp.intel.com>
 <20140220183613.GJ3200@reaktio.net>
 <A25F549E4D43CD42B4C02DF47A1913231105A665@SHSMSX103.ccr.corp.intel.com>
 <20140222134121.GP3200@reaktio.net>
In-Reply-To: <20140222134121.GP3200@reaktio.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pasi Kärkkäinen wrote on 2014-02-22:
> On Fri, Feb 21, 2014 at 02:22:11AM +0000, Cui, Dexuan wrote:
>> Pasi Kärkkäinen wrote on 2014-02-21:
>>> On Thu, Feb 20, 2014 at 07:59:04AM +0000, Cui, Dexuan wrote:
>>>> Hi all, We're pleased to announce an update to XenGT since its first
>>>> disclosure in last Sep.
>>> 
>>> Are you going to work on upstreaming this stuff? Xen 4.4 will be
>>> released soon(ish), so the Xen 4.5 development window starts in the near
>>> future and hopefully this stuff can be upstreamed then..
>> Hi Pasi,
>> We do plan to upstream but not give a timeframe so far.
>> 
> 
> Ok. Would you like to post an article on the Xen blog about XenGT ?
> I think that would be a good thing to do to get more visibility for this feature.
As I mentioned in the previous mail, we already have a blog article, which
can be easily found by googling xengt: :-)
https://01.org/xen/blogs/srclarkx/2013/graphics-virtualization-xengt

>>> Also: Haswell ("4th generation Intel core CPU") is listed as a
>>> requirement in the Setup Guide PDF.. will there be support for SNB/IVB
>>> GPUs aswell?
>> There is no plan for SNB/IVB.
>> 
> 
> Is that because of some hardware limitation on earlier GPU generations,
> or just a matter of amount of work needed to support XenGT on earlier
> GPUs?
> -- Pasi
No HW limitation on earlier GPUs -- actually you can even see some unused
codes about earlier generations in the linux-vgt.patch.
At present we'd like to focus on HSW (and newer generation in future).

-- Dexuan

