Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaAQBR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:17:29 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:40714 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751797AbaAQBR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <201401151057.43044.arnd@arndb.de>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
	<1389742458-7693-4-git-send-email-tinamdar@apm.com>
	<201401151057.43044.arnd@arndb.de>
Date: Thu, 16 Jan 2014 17:17:26 -0800
Message-ID: <CACoXjcmQ5esXH+8OSuFN0r_qLRt1fqfu+oZ56OnfOt4J2pWLvw@mail.gmail.com>
Subject: Re: [RFC PATCH V2 3/4] dt-bindings: pci: xgene pcie device tree bindings
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 1:57 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 15 January 2014, Tanmay Inamdar wrote:
>> This patch adds the bindings for X-Gene PCIe driver. The driver resides
>> under 'drivers/pci/host/pci-xgene.c' file.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  .../devicetree/bindings/pci/xgene-pcie.txt         |   45 ++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
>>
>> diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
>> new file mode 100644
>> index 0000000..19b9c28
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
>> @@ -0,0 +1,45 @@
>> +* AppliedMicro X-Gene PCIe interface
>> +
>> +Required properties:
>> +- status: Either "ok" or "disabled".
>
> "status" isn't normally a required property. The default interpretation is
> that a node without a status property is active.

ok. I will move 'status' under optional properties.

>
>> +- device_type: set to "pci"
>> +- compatible: should contain "xgene,pcie" to identify the core.
>> +- reg: base addresses and lengths of the pcie controller configuration
>> +     space register.
>
> Doesn't match the code or example: You only list one area here, but
> you actually need to register sets.

ok. I will update

>
> Looks good otherwise now.
>
>         Arnd
