Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3JaL1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:27:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60490 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751283Ab3JaL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:27:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for linux-3.8.
Date: Thu, 31 Oct 2013 12:39:21 +0100
Message-ID: <2226874.g7cLvQ5SiE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <cover.1383181113.git.lv.zheng@intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 31, 2013 09:07:40 AM Lv Zheng wrote:
> There are bug-fixes for AML interpreter upstreamed, fixing some serious
> issues found in recent platforms.  These fixes make Linux AML interpreter
> more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes should
> be based on such improvements, thus they are good materials for stable.
> 
> This patch set can be safely applied to linux-3.8:
> commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.
> 
> The patch set has passed build/boot tests on the following machines:
>   Dell Inspiron Mini 1010 (i386)
>   HP Compaq 8200 Elite SFF PC (x86-64)
> 
> Bob Moore (4):
>   ACPICA: Interpreter: Fix Store() when implicit conversion is not
>     possible.
>   ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
>     BufferField refs.
>   ACPICA: Return error if DerefOf resolves to a null package element.
>   ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
>     field.

Hi Greg,

Please take patches [1-4/4] for stable.

Rafael

