Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3LRPB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:01:57 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15948 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3LRPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:01:54 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-e6-52b1b8e098ca
From: Tomasz Figa <t.figa@samsung.com>
To: Alex Ling <kasimling@gmail.com>
Cc: rob.herring@calxeda.com, mark.rutland@arm.com, linux@arm.linux.org.uk,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ARM: dts: add board dts file for EXYNOS4412 based
 TINY4412 board
Date: Wed, 18 Dec 2013 16:01:36 +0100
Message-id: <1486025.NpqSQkmkfm@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1387373039-4738-1-git-send-email-kasimling@gmail.com>
References: <1387373039-4738-1-git-send-email-kasimling@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xK7oPdmwMMlh3ScNi/pFzrBbnXq1k
	tPh3dQ+LRe+Cq2wWmx5fY7W4vGsOm8WM8/uYLG5f5rVYev0ik8XhFQeYLF4dbGNx4PZYM28N
	o0dLcw+bx4LPV9g9ds66y+6xcvkXNo/NS+o9+rasYvT4vEnOY+Pc0ADOKC6blNSczLLUIn27
	BK6My3PnMhX8Ya1Yv/0uYwPjTZYuRk4OCQETic4N2xkhbDGJC/fWs3UxcnEICSxllLjQN48V
	wulikpjx6zkTSBWbgJrE54ZHbCC2iICyxM+LJ5lAipgF5jNJ/J/bDzZWWCBO4v/fRqAiDg4W
	AVWJHQ9sQMK8ApoSS/v+sYPY/ALqEu+2PQWbKSrgJvFi3xZ2kHJOAWeJgzfNQMJCAk4Spyfv
	ZIJoFZT4Mfke2HRmAXmJffunskLYWhLrdx5nmsAoOAtJ2SwkZbOQlC1gZF7FKJpamlxQnJSe
	a6hXnJhbXJqXrpecn7uJERJHX3YwLj5mdYhRgINRiYd3gc/GICHWxLLiytxDjBIczEoivEJb
	gUK8KYmVValF+fFFpTmpxYcYmTg4pRoYo3vnZN3+VLCid/1rXh410Xdtvn1W7jEbJWS1Jv87
	5Vn9N0jRKHvTt1y5lWv4fpU8uPFrS9ivgl0aW9K/6ZdvDvm4N3FJ5vVZriorm8PLfnx6EF7x
	dEdD9msGtYhvehe3C37fEvva95LjPhmv8itTYxawS7OkTqni+PhfzSOy8fV7i7CXupealFiK
	MxINtZiLihMBFoCocYECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wednesday 18 of December 2013 21:23:59 Alex Ling wrote:
> Add a minimal board dts file for EXYNOS4412 based FriendlyARM's
> TINY4412 board. This patch including support peripherals like
> UART, SD card on SDMMC2 port and GPIO connected LEDs.
> 
> Signed-off-by: Alex Ling <kasimling@gmail.com>
> ---
> Changes for v2:
>   - Clean up patch description
>   - Fix LED labels as Tomasz's suggested
>   - Fix style issues
> 
>  arch/arm/boot/dts/Makefile                |    1 +
>  arch/arm/boot/dts/exynos4412-tiny4412.dts |   93 +++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos4412-tiny4412.dts

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

