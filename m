Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbbA1BBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:01:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31687 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbbA1BBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:01:30 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-6e-54c834e829f5
Message-id: <54C834E7.8060203@samsung.com>
Date: Wed, 28 Jan 2015 10:01:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com, "kgene@kernel.org" <kgene@kernel.org>
Cc: =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?7J207IOB67Cw?= <sangbae90.lee@samsung.com>,
        =?UTF-8?B?64yA7J24?= =?UTF-8?B?6riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v10 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
References: <2091672023.141961422352757659.JavaMail.weblogic@epmlwas08c>
In-reply-to: <2091672023.141961422352757659.JavaMail.weblogic@epmlwas08c>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkWPeFyYkQg9/rOS0er1nMZLFxxnpW
	i0n3J7BYvH5haNH/+DWzxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyWHr9IpPF7cYVbBaP
	V7xlt2jde4Td4vingywWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlTF36SG2gmscFUv/32BpYPzJ1sXIySEhYCKxrfsTO4QtJnHh
	3nqwuJDAUkaJti4PmJo1x88CxbmA4osYJWb8ucYOUfSaUWL6Ph8Qm1dAS+Jw81MWEJtFQFXi
	78opTCA2G1B8/4sbYENFBcIkVk6/wgJRLyjxY/I9MFtEwFmiaeUasJnMAivZJA4sCwWxhQXS
	JJYc/cTcxcgBtMtD4tkOsBJOAU+JWT37oMrVJSbNW8QMYctLbF7zlhnkTgmBqRwS82fPYIK4
	R0Di2+RDLCBzJARkJTYdYIb4S1Li4IobLBMYxWYhuWgWkrGzkIxdwMi8ilE0tSC5oDgpvchE
	rzgxt7g0L10vOT93EyMwuk//ezZhB+O9A9aHGAU4GJV4eDfcPBYixJpYVlyZe4jRFOiKicxS
	osn5wBSSVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xv4Wg2fM3hUzA82f20zb+Gf510WsJ5i8/ol8zfkpfX3C8UuyIvp/nRTyjLg+cy5XSG8xFeTs
	/tfP1FC3YP72sFq7iQ5xtayn654WMDYI23pEnyszfFL/Uynj8KkFtw38jc63sfXwqQccOKdz
	fb1is9a1FJ5T63epaIVfnaaQEHb8S/arttaNSizFGYmGWsxFxYkAnIapy+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd0XJidCDH4rWDxes5jJYuOM9awW
	k+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovbjSvYLB6v
	eMtu0br3CLvF8U8HWSxW7frD6CDgsWbeGkaPnbPusnss3vOSyWPTqk42j81L6j36tqxi9Pi8
	SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH
	6HYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bcpYfYCq5xVCz9f4Ol
	gfEnWxcjJ4eEgInEmuNnoWwxiQv31gPZXBxCAosYJWb8ucYOkhASeM0oMX2fD4jNK6Alcbj5
	KQuIzSKgKvF35RQmEJsNKL7/xQ2wQaICYRIrp19hgagXlPgx+R6YLSLgLNG0cg3YTGaBlWwS
	B5aFgtjCAmkSS45+Yu5i5ADa5SHxbAdYCaeAp8Ssnn1Q5eoSk+YtYoaw5SU2r3nLPIFRYBaS
	DbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDqeCa1g3Flg8UhRgEORiUe
	3ojrx0KEWBPLiitzDzFKcDArifC+1TgRIsSbklhZlVqUH19UmpNafIjRFBgAE5mlRJPzgWkt
	ryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qB0T14XvMX05eO326s
	359yam2OwZn9gR9kHu8PlHkQtyQmv0qWL15z3jzzT1ppNXlTOwrEf4TUTz5U7LxTa1eI//HW
	iep+Hn9Xf6g7Om3mxX+PZK/++fQ/K34Ku/8iNcXOOVIPluadrza72ZE3/yWbW0PR+4Bmhb1/
	m783rzudtVxvpdVC/32pj5VYijMSDbWYi4oTAdi86tMzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Could you please pick remaining patches (patch4-patch7)?

On 01/27/2015 06:59 PM, MyungJoo Ham wrote:
>>  This patchset add new devfreq_event class to provide raw data to determine
>> current utilization of device  which is used for devfreq governor.
>>
>> The following description explains the feature of two kind of devfreq class:
>> - devfreq class (existing)
>>  : devfreq consumer device use raw data from devfreq_event device for
>>    determining proper current system state and change voltage/frequency
>>    dynamically using various governors.
>> - devfreq_event class (new)
>>  : Provide measured raw data to devfreq device for governor
> 
> Merged in my local git repo (1/7 to 3/7 as those three are in /drivers/devfreq).
> 
> However, the admin requires me to setup the firewall again, so please wait
> another day for the merged patches to show up in external network
> (git.kernel.org) and to make a pull-request for Rafael.
> (waiting firewall execption approvals from the admin)

Dear Myungjoo,

Thanks for your apply.

Best Regards,
Chanwoo Choi

