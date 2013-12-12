Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3LLMwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:52:45 -0500
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:44799 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751820Ab3LLMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:52:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131212114610.GA23971@mudshark.cambridge.arm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
	<1386151791-4881-3-git-send-email-vkale@apm.com>
	<20131209165003.GJ13908@mudshark.cambridge.arm.com>
	<CAPrCYkfS9h_yoQMcrQDXpW_3FcSfiPz0aeNX+_gc=G4exSEVWg@mail.gmail.com>
	<CAPrCYkct6XePhYEEC=x0yNQoS-z=fcp2_WKxU1Zk0eO=9+ZaLA@mail.gmail.com>
	<20131212114610.GA23971@mudshark.cambridge.arm.com>
Date: Thu, 12 Dec 2013 18:22:42 +0530
Message-ID: <CAPrCYkdy6uMmxGUkMfeMD65YCjrMYVRCzJoHt6uSOyCNoS0Zaw@mail.gmail.com>
Subject: Re: [PATCH V7 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 5:16 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Dec 12, 2013 at 06:33:59AM +0000, Vinayak Kale wrote:
>> > Below fixup works fine on APM platform.
>> > Do you want me to send this fixup as part of next revision of the
>> > patch or will you apply it yourself? (For later case, you have my ack)
>>
>> Any comments? Do I need to send the fix-up in next revision of patch?
>
> Looks fine to me; I've folded in my changes and applied it to my aarch64
> branch. I'll queue it for 3.14 when Catalin and I start putting that
> together.

Okay. Thanks :-)
