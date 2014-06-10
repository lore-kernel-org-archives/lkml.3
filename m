Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbaFJBaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:30:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25683 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaFJBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:30:16 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-2e-53965fa5b61c
Message-id: <53965FA5.3020901@samsung.com>
Date: Tue, 10 Jun 2014 10:30:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: regulator: Add regulator suspend state
 for PM state
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
 <1402309780-8118-3-git-send-email-cw00.choi@samsung.com>
 <20140609191645.GC5099@sirena.org.uk>
In-reply-to: <20140609191645.GC5099@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRsSkSHdp/LRgg5YlNhZTHz5hs5h/5Byr
	xYE/Oxgtzja9Ybf4dqWDyeLyrjlsFrcbV7BZtO49wu7A4bFz1l12j02rOtk87lzbw+bRt2UV
	o8fnTXIBrFFcNimpOZllqUX6dglcGfMeLmcvuCZe0f/0DEsD4xLhLkYODgkBE4mz3yS7GDmB
	TDGJC/fWs4HYQgJLGSUOTw6FiJtI9L+7zd7FyAUUn84osXxeO5TzmlFi7bpXTCBVvAJaEt0v
	mxhBhrIIqEocu6gDEmYDCu9/cQNsqKhAmMTK6VdYIMoFJX5MvgdmiwgoS1z9vpcFZCazwHZG
	ie077jODJIQFoiUmzJ0GddFyoMRLGxCbU8BIYnXzDbBmZgEdif2tEDXMAvISm9e8ZQYZJCFw
	i13i3vNp7CAJFgEBiW+TD7FAfCwrsekAM8RnkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKp
	BckFxUnpRYZ6xYm5xaV56XrJ+bmbGIHxd/rfs94djLcPWB9iTAZaOZFZSjQ5Hxi/eSXxhsZm
	RhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaPqc59bKDft2
	pGzV+iplNiX5YPGcytXzTh0t+ra89vK07UtrnkQdXezbuWCr5sFHW51PMnU1iDNfWB1Q2tb+
	p63/E/evf929TAH5aRMbtx06v9TPjPWf9oJTZYc/nbB/Hexkn/WjTi5KtatibpBn4CHXSf8v
	WkvWNrD+czrvpnt5zVOreTmcTkosxRmJhlrMRcWJAKdeyrXVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd2l8dOCDTa/MraY+vAJm8X8I+dY
	LQ782cFocbbpDbvFtysdTBaXd81hs7jduILNonXvEXYHDo+ds+6ye2xa1cnmcefaHjaPvi2r
	GD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx7+Fy9oJr4hX9
	T8+wNDAuEe5i5OSQEDCR6H93mx3CFpO4cG89WxcjF4eQwHRGieXz2tkhnNeMEmvXvWICqeIV
	0JLoftnE2MXIwcEioCpx7KIOSJgNKLz/xQ02EFtUIExi5fQrLBDlghI/Jt8Ds0UElCWuft/L
	AjKTWWA7o8T2HfeZQRLCAtESE+ZOA2sWElgOlHhpA2JzChhJrG6+AdbMLKAjsb8VooZZQF5i
	85q3zBMYBWYh2TELSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH+DOpHYwr
	GywOMQpwMCrx8FocmBosxJpYVlyZe4hRgoNZSYSX9SNQiDclsbIqtSg/vqg0J7X4EGMyMAQm
	MkuJJucDk09eSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDy
	R62fdv13x21NoYLKn/XL737bdFLVoeuisfOBp7e+/J79fdqzxOYdBVdE2m5eKqh2VnotZeby
	+3HqtTMLD825pc5y3KMxNvPg1nb5LdfWbNh57ryc3SUff4HzGbMdtwVFeihv4wtzjs/l8XzQ
	LScY6zuneO23PUI3pwsazs/02vn/jbvEXk4pJZbijERDLeai4kQAx5K/TjQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 06/10/2014 04:16 AM, Mark Brown wrote:
> On Mon, Jun 09, 2014 at 07:29:40PM +0900, Chanwoo Choi wrote:
> 
>> +- regulator-initial-state: initial state for suspend state
>> +- regulator-state-[standby/mem/disk] sub-root node for suspend state
>> +	regulator-volt: voltage consumers may set in suspend state
>> +	regulator-mode: voltage mode in suspend state
>> +	regulator-on-in-suspend: regulator should be on in suspend state
>> +	regulator-off-in-suspend: regulator should be off in suspend state
> 
> These need to define what the states are in general terms - in
> particular it's very unclear what standby is and how it differs from
> suspend to RAM.  You also need to define what happens if neither
> X-in-suspend property is set.

OK, I'll add more description.

> 
>> +		regulator-state-mem {
>> +			regulator-volt = <1000000>;
>> +			regulator-mode = <0x8>;
>> +			regulator-off-in-suspend;
>> +		};
> 
> Probably best to remove mode from this.
> 

OK, I'll remove it. (regulator-mode)


I modify description as following. Please review this description.

--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -19,6 +19,24 @@ Optional properties:
   design requires. This property describes the total system ramp time
   required due to the combination of internal ramping of the regulator itself,
   and board design issues such as trace capacitance and load on the supply.
+- regulator-initial-state: initial state for suspend state
+- regulator-state-standby sub-root node for Standby mode
+  : the device is in a power-saving state, but can also receive certain events,
+  specific behavior depends on the specific device.
+- regulator-state-mem sub-root node for Suspend-to-RAM mode
+  : suspend to memory, the device goes to sleep, but all data stored in memory,
+  only some external interrupt can wake the device.
+- regulator-state-disk sub-root node for Suspend-to-disk mode
+  : suspend to disk, this state operates similarly to Suspend-to-RAM,
+  but includes a final step of writing memory contents to disk.
+- regulator-state-[standby/mem/disk] node has following common properties:
+	- regulator-volt: voltage consumers may set in suspend state.
+	- regulator-mode: voltage mode in suspend state.
+	- regulator-on-in-suspend: regulator should be on in suspend state.
+	- regulator-off-in-suspend: regulator should be off in suspend state.
+	If node don't include regulator-[on/off]-in-suspend, can't change
+	regulator state in suspend mode and only should sustain the regulator
+	state of normal state.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -34,6 +52,11 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+
+		regulator-state-mem {
+			regulator-volt = <1000000>;
+			regulator-off-in-suspend;
+		};
 	};
 

Best Regards,
Chanwoo Choi

