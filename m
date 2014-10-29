Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaJ2IgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:36:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54209 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbaJ2IgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:36:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2] Documentation: gpio: guidelines for bindings
Date: Wed, 29 Oct 2014 09:36:11 +0100
Message-ID: <4218554.VFiN8kJDb1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
References: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+x3LzzPiZw1Vx72UI/VMvmfXAbmM+hQ1M7Gn9KbFRzg
 XYhGUp8KeeF0NBr3e5vTyLJpSO3nlHFVNLsBLcq3gRRB0iPjIl
 px47gjqhtJNcmXCLe/BBNGAkvS1TC5rQWYGSUHWM3X0lrsspxW
 Pqz52N8YnLfNCXdtHVLmE3UXRICqQcQ7l2CiKZ1pGmTB+wf/vH
 Qa3f93Rh73hYDK0MK2s5lQwkU+egbXsq0QMOZ7DZdjSfR4Vo+A
 llC1Up6L/P6OB3r8VDlIKNkxOFvmZKOWPOJmFEiFtMZMqZvBlA
 zd5tx/KDJrhmqL6b5llg0YWAgsU0VH91Abe0A7GvyVmn9Fu1LJ
 pxhot4kFXGKnUZ4WKCtk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 17:13:14 Alexandre Courbot wrote:
> Now that ACPI supports named GPIO properties, either through ACPI 5.1 or
> the per-driver ACPI GPIO mappings, we can be more narrow about the way
> GPIOs should be specified in Device Tree bindings.
> 
> This patch updates the GPIO DT bindings documentation to highlight the
> following rules for new GPIO bindings:
> 
> - All new bindings must have a meaningful name (e.g. the "gpios"
>   property must not be used)
> - The only suffix allowed is "-gpios", no matter the number of
>   descriptors in the property
> - GPIOs can only be grouped under the same property when they serve the
>   same purpose, a case that should remain exceptional (e.g. bit-banged
>   data lines).
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rafael J. Wysocki <rjw@rjwysocki.net>
> CC: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
