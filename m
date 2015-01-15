Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbbAOUUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:20:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbAOUT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:19:58 -0500
Message-ID: <54B820E7.4080406@canonical.com>
Date: Thu, 15 Jan 2015 15:19:51 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH][v3.16.y-ckt] ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider including mainline commit c12f07d and bd9b2f9 in the
next v3.16.y-ckt release.  They
were included in the mainline tree as of v3.17-rc1.  A test kernel has
been built and tested, which was confirmed to resolve:
http://bugs.launchpad.net/bugs/1406767 .

commit c12f07d17c12193256a99e20c9a0f130fb8f7be8
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Wed Jul 23 13:12:16 2014 +0800

    ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.


Commit c12f07d does not cherry-pick cleanly in 3.16.y.  However, it will
if commit bd9b2f9aff26c185c1f8e0cd08a850ee4ace391a is cherry picked first:

commit bd9b2f9aff26c185c1f8e0cd08a850ee4ace391a
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon Jul 14 22:41:41 2014 +0200

    ACPI / scan: No implicit wake notification for buttons

   


Sincerely,
Joseph Salisbury


