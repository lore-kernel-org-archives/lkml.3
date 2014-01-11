Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaAKBL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:11:58 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:60703 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751841AbaAKBLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:11:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140108100549.GE6701@e106331-lin.cambridge.arm.com>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<1389135041-16062-2-git-send-email-fkan@apm.com>
	<20140108100549.GE6701@e106331-lin.cambridge.arm.com>
Date: Fri, 10 Jan 2014 17:11:53 -0800
Message-ID: <CAL85gmCEk3c1qbo978qHssrz0toxbCT3LiTinX5ZZcwg-Q-FnA@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot
 dts node.
From: Feng Kan <fkan@apm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 2:05 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Jan 07, 2014 at 10:50:36PM +0000, Feng Kan wrote:
>> Add X-Gene reboot device tree node documentation.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  .../devicetree/bindings/arm64/xgene/reboot.txt     |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm64/xgene/reboot.txt b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
>> new file mode 100644
>> index 0000000..51d23c1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm64/xgene/reboot.txt
>> @@ -0,0 +1,10 @@
>> +Reboot property to control system reboot on storm platforms:
>> +
>> +The register attribute contain the address of the reset register.
>
> Required properties:
>
> - compatible: should contain "apm,xgene-reboot"
>
> - reg: the base address and size of the reset register.
>
>> +
>> +Example:
>> +
>> +     reboot@0 {
>> +             compatible = "apm,xgene-reboot";
>> +             reg = <0x0 0x17000014 0x0 0x4>;
>> +     };
>
> Given this seems to be a 64-bit address, the unit address should
> preferably be 0,17000014 rather than just 0.

FKAN: Mark, can I keep this as it is to be consistent with the reset
of the file?
>
> Thanks,
> Mark.
