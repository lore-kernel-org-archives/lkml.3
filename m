Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaIIGxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:53:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbaIIGxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:53:00 -0400
Message-ID: <540EA37E.6040005@redhat.com>
Date: Tue, 09 Sep 2014 02:51:42 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        linaro-acpi@lists.linaro.org, Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Olof Johansson <olof@lixom.net>, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support
 for probing from ACPI
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <20140902162606.GX29327@sirena.org.uk> <2913007.3xRNb2X4ts@vostro.rjw.lan> <4569324.eR9S3K10NB@wuerfel>
In-Reply-To: <4569324.eR9S3K10NB@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 09/03/2014 11:09 AM, Arnd Bergmann wrote:
> On Wednesday 03 September 2014 01:00:23 Rafael J. Wysocki wrote:

>> Our intention is specifically not to use "random incompatible bindings"
>> in that.  We'd rather have a common venue and process for establishing
>> new bindings for both DT and _DSD in a compatible way.
> 
> Right, I think everyone is on the same page for the embedded x86 case,
> my point was that there is no consensus about that yet among the
> parties involved in arm64 servers.

However, in the case of MAC devices where you might need to specify just
a couple of properties using _DSD, a specific set of discussions has
been instigated. As you mentioned, though, this pertains only to certain
devices and isn't necessarily true for every Ethernet device.
Consequently, while a Juno PoC patch might use a kludge today, that
doesn't mean it's a limitation of ACPI, just of certain devices.

Jon.

