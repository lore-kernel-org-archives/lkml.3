Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaADRsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:48:25 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40820 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaADRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:48:20 -0500
Date: Sat, 4 Jan 2014 19:48:13 +0200
From: Gleb Natapov <gleb@minantech.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
Message-ID: <20140104174813.GL10961@minantech.com>
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com>
 <2513222.AheLcigoE8@vostro.rjw.lan>
 <52C7C7EE.1070407@redhat.com>
 <1676077.d8A9e8eo7M@vostro.rjw.lan>
 <52C84733.1090507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C84733.1090507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 06:38:59PM +0100, Paolo Bonzini wrote:
> Il 04/01/2014 15:38, Rafael J. Wysocki ha scritto:
> > Well, it's just a sanity check and it makes the problem go away for the reporter.
> > 
> >> > Your patch is welcome but perhaps it should have a WARN_ON too.
> > It has been pulled in already, so the WARN_ON() can only be added via a separate
> > patch now.  Would you like to prepare that patch?
> 
> Yes, I'll add it together with the CPUID check.  I'll send the patch so
> that it can get into 3.14.
> 
CPUID check, while correct, will sweep the problem under the rug. Current
Linux logic should detect non working pstate in KVM. We should look into
why this is not happening for nested.

--
			Gleb.
