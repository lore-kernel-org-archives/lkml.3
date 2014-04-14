Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaDNS12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:27:28 -0400
Received: from david.siemens.de ([192.35.17.14]:60680 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaDNS11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:27:27 -0400
Message-ID: <534C2884.7050004@siemens.com>
Date: Mon, 14 Apr 2014 20:27:16 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jailhouse <jailhouse-dev@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Sabony, Mazda" <Mazda.Sabony@amd.com>
Subject: Developer wanted: AMD64 port of Jailhouse hypervisor
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

so far the Linux-based Jailhouse hypervisor [1] is only available for
Intel x86 CPUs. I'm now very happy to announce that AMD is offering to
sponsor the initial port of Jailhouse to the AMD64 architecture. Our
resources here are unfortunately bound to different tasks, but if anyone
out there with the required skills is interested in working on this
project, just reply to this email or contact me and Mazda directly.

The work to be done is manageable: we basically need corresponding
implementations of vmx.c and vtd.c in the current Jailhouse code base -
provided our existing abstractions were done right. Someone familiar
with virtualization on x86 in general and, ideally, even on AMD
processors should be able to complete this task within a couple of weeks.

For more details on the Jailhouse architecture and implementations, see
our slowly growing Documentation folder in the source tree or simply ask
on the mailing list.

Jan

[1] https://github.com/siemens/jailhouse

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
