Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3IMGjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:39:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36792 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3IMGjO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Fri, 13 Sep 2013 02:39:14 -0400
Message-Id: <5232CF2C02000078000F2ED9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 13 Sep 2013 07:39:08 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "KY Srinivasan" <kys@microsoft.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
 <52325C1E.90101@zytor.com>
 <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.09.13 at 03:43, KY Srinivasan <kys@microsoft.com> wrote:

> 
>> -----Original Message-----
>> From: H. Peter Anvin [mailto:hpa@zytor.com]
>> Sent: Thursday, September 12, 2013 5:28 PM
>> To: KY Srinivasan
>> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de 
>> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
>> from the hypervisor
>> 
>> On 09/12/2013 05:06 PM, KY Srinivasan wrote:
>> >
>> > Peter,
>> >
>> > Let me know if you want me to address any additional issues in this patch.
>> >
>> 
>> Please address Jan and Gleb's feedback.
> 
> Gleb's feedback was a question and I answered that as I did Jan's feedback 
> as well.
> Gleb, Jan, please let me know if there is something else you want addressed 
> here.

Indeed, apart from the question whether to change that one
message's level from KERN_INFO to KERN_DEBUG, there was
nothing really left unexplained (the aspect of the artificial tying
together of distinct features is really something KY has to
decide - I merely tried to point out that this is odd).

Jan

