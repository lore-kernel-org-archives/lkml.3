Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaADOYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 09:24:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60186 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753384AbaADOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 09:24:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Date: Sat, 04 Jan 2014 15:38:31 +0100
Message-ID: <1676077.d8A9e8eo7M@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52C7C7EE.1070407@redhat.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <2513222.AheLcigoE8@vostro.rjw.lan> <52C7C7EE.1070407@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 04, 2014 09:35:58 AM Paolo Bonzini wrote:
> Il 03/01/2014 23:46, Rafael J. Wysocki ha scritto:
> > Well, fixing the KVM bug is surely welcome.
> > 
> > That said, adding checks to ensure that your assumptions are valid is rarely
> > wrong, especially if they are done once per kernel boot.  And the kernel only
> > should panic if it cannot continue to run, which isn't the case here.
> 
> I agree, but I suspect even your check is already late.

Well, it's just a sanity check and it makes the problem go away for the reporter.

> Your patch is welcome but perhaps it should have a WARN_ON too.

It has been pulled in already, so the WARN_ON() can only be added via a separate
patch now.  Would you like to prepare that patch?

Rafael

