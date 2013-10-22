Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3JVRVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:21:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:49887 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3JVRVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:21:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="378411515"
From: "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: =?iso-8859-7?Q?Vladimir_=27=F6-coder/phcoder=27_Serbinenko?= 
	<phcoder@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "keir@xen.org" <keir@xen.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Thread-Topic: EFI and multiboot2 devlopment work for Xen
Thread-Index: AQHOzl01U2QqStCwI06ZIUY46NKV8Zn/osgAgABUwACAAPKqAIAAAVgAgAAD9ICAAAPwgIAAPmUAgAAQ2ICAAAvggIAAAgsAgAACuACAAAVUAIAABkaA//+N9YCAAHm2AP//kuoA
Date: Tue, 22 Oct 2013 17:21:15 +0000
Message-ID: <CE8C01A3.244A%richard.l.maliszewski@intel.com>
In-Reply-To: <20131022165140.GL3626@debian70-amd64.local.net-space.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.8.130913
x-originating-ip: [10.252.138.123]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <F9771C2F275A674F9DEB742EE49FCF05@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latter.  The code I was looking at definitely has the linuxefi
directive.  FWIW, if you install FC18/19 on an EFI system, the grub2
config file uses the linuxefi and companion initrd directives for launch.

--Richard

On 10/22/13 9:51 AM, "Daniel Kiper" <daniel.kiper@oracle.com> wrote:

>On Tue, Oct 22, 2013 at 04:36:04PM +0000, Maliszewski, Richard L wrote:
>> I may be off-base, but when I was wading through the grub2 code earlier
>> this year, it looked to me like it was going to refuse to launch
>>anything
>> via MB1 or MB2 if the current state was a secure boot launch.
>
>Are you talking about upstream GRUB2 or GRUB2 with tons of distros
>patches including linuxefi one. If later one it could be the case.
>
>Daniel

