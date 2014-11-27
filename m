Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaK0HVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:21:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26335 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK0HVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:21:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-79-5476d0efc2fb
From: Kukjin Kim <kgene@kernel.org>
To: "'Chander Kashyap'" <k.chander@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, daniel.lezcano@linaro.org,
        lorenzo.pieralisi@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, rjw@rjwysocki.net
References: <1415683897-983-1-git-send-email-k.chander@samsung.com>
In-reply-to: <1415683897-983-1-git-send-email-k.chander@samsung.com>
Subject: RE: [PATCH v5] arm64: dts: exynos7: add support for cpuidle core power
 down
Date: Thu, 27 Nov 2014 16:21:19 +0900
Message-id: <08b101d00a12$bd15dc80$37419580$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGuTKUUdO98DE9jEYo7OD2CaqGVpZy3i/ZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zI933F8pCDJYvF7N4v6yH0WLeZ1mL
	VRuWsFhsenyN1eLyrjlsFp97jzBazDi/j8nize8X7BZLr19ksjhz+hKrA5fHmnlrGD3uXNvD
	5rF5Sb3HlqvtLB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVsfLiaqaCyaIVO2ZfZmtgnCPQ
	xcjJISFgInF2/X5GCFtM4sK99WwgtpDAMkaJjj5WmJrDr/4xdzFyAcUXMUqsfriWCcL5yyhx
	7OZqoG4ODjYBZYnGJn2QBmEBLYmFW5pYQGpEgNZI3GtvBmtgFljCKLHg8RImiBXOEkePtbGD
	2JwCLhI75r9hhegOk1j0dxvYSSwCqhI9z2eAncQrYCGxZdocFghbUOLH5HtgNjPQtvU7jzNB
	2PISm9e8ZYY4W0Fix9nXYHNEBIwkes7sZYOoEZHY9+IdI8hBEgJTOSQ2Tv7LBrFMQOLb5EMs
	IN9ICMhKbDoANUdS4uCKGywTGCVnIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi
	0rx0veT83E2MkOjv28F484D1IUYBDkYlHl6LA2UhQqyJZcWVuYcYTYEumsgsJZqcD0wxeSXx
	hsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAr02Gy2tDfi
	l9GZs+3h31y5hsuCHvZ3/qyPn5YUsmmdFEPUNPnrctG9KytDXrxXErHkuVLQ82iK0yTbHR90
	js+1mh/wRMGX2Z/36Zmc6LIH6/Z/EZ3ZsEtRn1u7ovpHVFjOynWJiUf2zPueXGz2KlfPI3Pz
	tEMBPhXJa1acexjzY0VmzTU5aSWW4oxEQy3mouJEADVsYZn5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd33F8pCDGYuFrR4v6yH0WLeZ1mL
	VRuWsFhsenyN1eLyrjlsFp97jzBazDi/j8nize8X7BZLr19ksjhz+hKrA5fHmnlrGD3uXNvD
	5rF5Sb3HlqvtLB59W1YxenzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCOMWPlxdVMBZNFK3bMvszWwDhHoIuRk0NCwETi8Kt/zBC2mMSFe+vZuhi5OIQEFjFKrH64
	lgnC+csocezmasYuRg4ONgFlicYmfZAGYQEtiYVbmlhAakSAxknca28Ga2AWWMIoseDxEiaQ
	KiEBZ4mjx9rYQWxOAReJHfPfsEJ0h0ks+ruNEcRmEVCV6Hk+gw3E5hWwkNgybQ4LhC0o8WPy
	PTCbGWjb+p3HmSBseYnNa95Cna0gsePsa7A5IgJGEj1n9rJB1IhI7HvxjnECo/AsJKNmIRk1
	C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITi7PpHYwrmywOMQowMGoxMNr
	caAsRIg1say4MvcQowQHs5IIr9QioBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJLiSbnAxNfXkm8
	obGJmZGlkZmFkYm5uZI4742buSFCAumJJanZqakFqUUwfUwcnFINjPEnrlur3tjPPNFF3WiB
	/ln1nU9fzvn2N/q2Ybrd2msG7roceo8OR1X4TVgTGHtUfFXV/+wgd9E9gh4v7co+HlV3ezX3
	89HkwINZdyTqdiUEK004zHXo9aZvd4TnRux35Hj9R+VPf8kRn3uS8QoHSzeJJdZN3Zt+xv7n
	t517omy+tqarsx1cFazEUpyRaKjFXFScCAAVewOwRAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chander Kashyap wrote:
> 
> Exynos7 supports multiple idle states. Core power down is one such
> idle state, where cores can be powered off independently.
> 
> This patch adds support for core power down idle state.
> 
> Entry latency for core power down idle state is calculated as follows:
> 1. Time difference is measured between cpuidle entry and exit.
> 2. WFI is skipped for measuring the time.
> 3. Select the worst case time in a set of 100000 cpuidle transactions,
>    with varying load.
> 
> Exit latency and min residency values are supplied as per HW team.
> 
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Lorenzo, thanks for your ack. Will apply.

- Kukjin

> ---
> This patch has following dependencies:
> 	- [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
> 		www.spinics.net/lists/arm-kernel/msg375961.html
> Changes in v2:
> 	- Moved the cpu-idle-state property after reg property
> 	- removed the status property.
> Changes in v3:
> 	- Added the Entry latency calculation in commit message.
> Changes in v4:
> 	- Corrected the commit message.
> 	- Corrected the entry latency value.
> Changes in v5:
> 	- Commit message modified
> 
>  arch/arm64/boot/dts/exynos/exynos7.dtsi | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> index d7a37c3..891eef4 100644
> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
> @@ -37,6 +37,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			reg = <0x0>;
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
> 
>  		cpu@1 {
> @@ -44,6 +45,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			reg = <0x1>;
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
> 
>  		cpu@2 {
> @@ -51,6 +53,7 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			reg = <0x2>;
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
>  		};
> 
>  		cpu@3 {
> @@ -58,6 +61,20 @@
>  			compatible = "arm,cortex-a57", "arm,armv8";
>  			reg = <0x3>;
>  			enable-method = "psci";
> +			cpu-idle-states = <&CPU_SLEEP>;
> +		};
> +
> +		idle-states {
> +			entry-method = "arm,psci";
> +
> +			CPU_SLEEP: cpu-sleep {
> +				compatible = "arm,idle-state";
> +				local-timer-stop;
> +				arm,psci-suspend-param = <0x0010000>;
> +				entry-latency-us = <34>;
> +				exit-latency-us = <150>;
> +				min-residency-us = <2100>;
> +			};
>  		};
>  	};
> 
> --
> 1.9.1

