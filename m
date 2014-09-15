Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaIOOMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:12:32 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56097 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaIOOMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:12:30 -0400
Date: Mon, 15 Sep 2014 10:11:20 -0400 (EDT)
Subject: Re: [PATCH v4 10/18] ACPI / table: Print GIC information when MADT
 is parsed
From: Jon Masters <jcm@redhat.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-acpi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linaro-acpi@lists.linaro.org,
        Robert Richter <rric@kernel.org>, Charles.Garcia-Tobin@arm.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        Jason Cooper <jason@lakedaemon.net>
MIME-Version: 1.0
Message-ID: <110210623.13993550.1410790280170.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.0.6_GA_5922 (MobileSync - Android/4.4.4-EAS-2.0)
In-Reply-To: <20140915064010.GD26649@localhost>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-11-git-send-email-hanjun.guo@linaro.org> <20140915064010.GD26649@localhost>
Thread-Topic: ACPI / table: Print GIC information when MADT is parsed
Thread-Index: EFjzTF77i+00kwVAU+3MZ5w/wtcVRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

How about having it verbose in the initial implementation (in case there are any fun times bringing up early systems) and then revisiting this? x86 is very verbose but it can be helpful.

Jon.

-- 
Computer Architect | Sent from my #ARM Powered Mobile device

On Sep 15, 2014 12:34 AM, Olof Johansson <olof@lixom.net> wrote:
>
> On Fri, Sep 12, 2014 at 10:00:08PM +0800, Hanjun Guo wrote: 
> > When MADT is parsed, print GIC information to On Fri, Sep 12, 2014 at 10:00:08PM +0800, Hanjun Guo wrote:
> When MADT is parsed, print GIC information to make the boot
> log look pretty.

If you do this for prettiness, having an example output in the commit
message would be a nice touch.

The question is why it's needed though? Do we really need all this verbose
information in dmesg when it could be found out in other ways instead?

x86 is notoriously verbose in some of these aspects, I'm not sure it's
something we need to mimic here?


-Olof
