Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaADRjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:39:16 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43353 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaADRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:39:13 -0500
Message-ID: <52C84733.1090507@redhat.com>
Date: Sat, 04 Jan 2014 18:38:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Gleb Natapov <gleb@kernel.org>, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <2513222.AheLcigoE8@vostro.rjw.lan> <52C7C7EE.1070407@redhat.com> <1676077.d8A9e8eo7M@vostro.rjw.lan>
In-Reply-To: <1676077.d8A9e8eo7M@vostro.rjw.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/01/2014 15:38, Rafael J. Wysocki ha scritto:
> Well, it's just a sanity check and it makes the problem go away for the reporter.
> 
>> > Your patch is welcome but perhaps it should have a WARN_ON too.
> It has been pulled in already, so the WARN_ON() can only be added via a separate
> patch now.  Would you like to prepare that patch?

Yes, I'll add it together with the CPUID check.  I'll send the patch so
that it can get into 3.14.

Paolo
