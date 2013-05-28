Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab3E1PCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:02:19 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34565 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934300Ab3E1PCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:02:17 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 17:02:16 +0200
Message-ID: <CADDKRnDH130wn8nVaT4xmCuEEcsGyBcjhj7pDjPMkeucUW+EWw@mail.gmail.com>
Subject: [v3.10-rc] intel_pstate question
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dirk.j.brandewie@intel.com, rafael.j.wysocki@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the sysfs-interface of intel_pstate is different to that of the acpi driver:
- intel_pstate shows current cpu-frequency in "cpuinfo_cur_freq" whereas
  the acpi counterpart uses "scaling_cur_freq".
- moreover cpuinfo_cur_freq is readable by root only, whereas
  scaling_cur_freq is world readable.

  A monitoring tool must take care of theese differences.
  Is this intentional?

Thanks, Jörg

Please CC me in answeres, I'm not subscribed.
