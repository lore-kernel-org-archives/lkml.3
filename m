Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3DZOiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:38:13 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:40655 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3DZOiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:38:11 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Fleming, Matt" <matt.fleming@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/efi2] efivars: efivar_entry API
Thread-Topic: [tip:x86/efi2] efivars: efivar_entry API
Thread-Index: AQHOPHFEzrlus8pItEq77hQ4E6Icb5jomzHAgABFgwD//71g0A==
Date: Fri, 26 Apr 2013 14:37:44 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E92@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
	<A5ED84D3BB3A384992CBB9C77DEDA4D41AFD1E51@USINDEM103.corp.hds.com>
 <CAL01qpumczY1Rw9tYqVDkkA0CDE45bNxXCY6bH0cNHhrzLS8ww@mail.gmail.com>
In-Reply-To: <CAL01qpumczY1Rw9tYqVDkkA0CDE45bNxXCY6bH0cNHhrzLS8ww@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-26_05:2013-04-26,2013-04-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304260108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Did you mount the efivarfs file system there?

Ah...
It worked by mounting efivarfs.

Thanks.


> -----Original Message-----
> From: Fleming, Matt [mailto:matt.fleming@intel.com]
> Sent: Friday, April 26, 2013 10:35 AM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; mingo@kernel.org; hpa@zytor.com; mjg59@srcf.ucam.org; tony.luck@intel.com; jk@ozlabs.org;
> teg@jklm.no; tglx@linutronix.de; mikew@google.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
> 
> On 26 April 2013 15:28, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> > Matt,
> >
> > I built a tip tree With CONFIG_EFIVAR_FS=y.
> > But, I can't see any entries in the directory of /sys/firmware/efi/efivarfs...
> >
> > I'm not sure if it is a problem.
> > Just let you know.
> 
> Did you mount the efivarfs file system there?
