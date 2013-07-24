Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3GXHtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:49:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36573 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3GXHtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:49:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Wilson <msw@amazon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel@lists.xensource.com, Daniel Kiper <daniel.kiper@oracle.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Brandon Philips <brandon@ifup.org>
References: <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
	<20130719151243.GA15488@kroah.com>
	<20130719183235.GA12267@debian70-amd64.local.net-space.pl>
	<20130719191449.GA1882@kroah.com> <51E9A85D.2060206@zytor.com>
	<20130722170307.GB14451@debian70-amd64.local.net-space.pl>
	<87wqoise9d.fsf@xmission.com> <51ED78EE.9020903@zytor.com>
	<20130722183315.GA29273@kroah.com>
	<20130724002235.GA15047@u109add4315675089e695.ant.amazon.com>
	<20130724004058.GA20327@kroah.com>
Date: Wed, 24 Jul 2013 00:49:25 -0700
In-Reply-To: <20130724004058.GA20327@kroah.com> (Greg KH's message of "Tue, 23
	Jul 2013 17:40:58 -0700")
Message-ID: <87ob9so0sa.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19wkFMC0MfmqIVgReK4v0cAyBc32dwg+M8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [Xen-devel] is kexec on Xen domU possible?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Tue, Jul 23, 2013 at 05:22:36PM -0700, Matt Wilson wrote:
>> On Mon, Jul 22, 2013 at 11:33:15AM -0700, Greg KH wrote:
>> > On Mon, Jul 22, 2013 at 11:24:46AM -0700, H. Peter Anvin wrote:
>> > > On 07/22/2013 10:20 AM, Eric W. Biederman wrote:
>> 
>> Many Xen-based cloud providers provide a mechanism for users to boot
>> the kernels they want. For example you can use PV-GRUB on EC2
>> instances to boot a kernel that is stored within an AMI.
>> 
>> For more info:
>>   http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UserProvidedkernels.html
>
> Yes, that's quite true, but some don't, or they make it difficult to do
> so.  Using kexec also allows you to "be the bootloader" and decide on
> _which_ kernel you want to boot, independant of what cloud provider you
> use, something that lots of people want in their quest to not dependant
> on any one company.

I would be more than happy to review and help get something merged that
sorts out kexec on Xen.

Eric

