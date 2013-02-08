Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946361Ab3BHNe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:34:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946075Ab3BHNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:34:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 05/11 V2] mei: bus: Call bus routines from the core code
Date: Fri, 08 Feb 2013 14:34:49 +0100
Message-ID: <1672492.QPn8YfMt1A@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-4-generic; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1360326504-17041-6-git-send-email-tomas.winkler@intel.com>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com> <1360326504-17041-6-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NxrADvPOeib49OL0c2o8pK4GyDZTr4kFzBZ1lNrVDI+
 jqz+6/cIWxpcqDuoDFwFSMU/9tdSwiCuXRKvdOehkgckAXLuog
 ZbNTUjv8hp1GWne6PX5ARPJFjE/iN3+8APo12EPFUEH6TkYTlu
 gpOLhWtlDi2/CDgA6kvBjjCHUJ790op0f2gUlghYk8eegpMiff
 JKXjEYOQ/p7b+8pjls+/1PfZc+1TZnPK1f0lvlFRE19yPYdZEU
 lgAM/l/Ixi6jVKq95dW5P3tHoZIgyJ6MJHsBwyzj9/8DjdN5Bq
 vO7fd/QUj79n+pyqv+ctbM5N/1bXRoN69DumUx0rGcVjZUT2sq
 F+94bVzLcsv3ysm3vfTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2013 14:28:18 Tomas Winkler wrote:
> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> Register the MEI bus type against the kernel core bus APIs and
> call the bus Rx handler from interrupt.c
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
