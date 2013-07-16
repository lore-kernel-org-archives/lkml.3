Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3GPLdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:33:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16101 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3GPLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:33:29 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-c2-51e52f881d8d
Date: Tue, 16 Jul 2013 13:33:19 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 7/7] Documentation:cpufreq:boost: Update BOOST
 documentation
Message-id: <20130716133319.49ed0838@amdc308.digital.local>
In-reply-to: <CAKohpo=oB_4gGtNn6jvxSCp665pOq6oqeTCCyGzmN_eWqt0Lhg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-8-git-send-email-l.majewski@samsung.com>
 <CAKohpo=oB_4gGtNn6jvxSCp665pOq6oqeTCCyGzmN_eWqt0Lhg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xoG6H/tNAg/tvJC3+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	rozn746zFrzlqHj04RxrA+Nk9i5GTg4JAROJ720NzBC2mMSFe+vZuhi5OIQEpjNKPPxygQnC
	aWeSuLTmHRtIFYuAqsSCo0fAOtgE9CQ+333KBGKLCPhKLFq0GayBWeAcs8Til8tYQRLCAqES
	bR03wJp5Bawlth18zghicwoESxy/eQzMFhJoYZLY/jMSxOYXkJRo//cD6iQ7iXOfNrBD9ApK
	/Jh8jwXEZhbQkti8rYkVwpaX2LzmLfMERsFZSMpmISmbhaRsASPzKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgWHomvYNxVYPFIUYBDkYlHt6DnE8ChVgTy4orcw8xSnAwK4nw3uJ/GijE
	m5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBkYcld+Yllh7x
	mwHHX5qmfzj4kPeafuFHlUpG1a6SyZe5fPdrnatuurcgpGrBS/GTz7xtWm4eLrs0x28fw93z
	kd7nNqW9r/kaIyBQmOrkau6r4GEjaKr4yfSJ4odp+Y/CbJYo9666k8N+RinrlKum6+/X051V
	T++8lMLEnBFzQeCIf4GsyRRTJZbijERDLeai4kQACaSgW6ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 15:31:43 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > -Reading the file is always supported, even if the processor does
> > not -support boosting. In this case the file will be read-only and
> > always -reads as "0". Explicitly changing the permissions and
> > writing to that -file anyway will return EINVAL.
> > +The file is exported only when cpufreq driver supports boosting.
> > +Explicitly changing the permissions and writing to that file
> > anyway will +return EINVAL.
> 
> For acpi-cpufreq reading the file should be always supported. And this
> must be mentioned in doc.

As fair as I've understood our previous discussion (at [*]) we have
agreed about this. We only export boost attribute when it is supported
by cpufreq_driver. Rafael was very clear about exporting boost
attribute:

"Simple: Export it only when supported."

[*]: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
