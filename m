Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3DYC2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 22:28:33 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:35255 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3DYC2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 22:28:32 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 10:28:31 +0800
Message-ID: <CACbbJyYJ7R8We1_uFGKrjvSa2ZqrTHemESZKY0qwSyc01MMYfg@mail.gmail.com>
Subject: [QUERY] cpuidle in SYSFS: /sys/devices/system/cpu/cpu0/cpuidle/state0/desc
From: Ren Zhen <darwin.xupt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
In /Documentation/cpuidle/sysfs.txt, It says:
"desc : Small description about the idle state(string)".

when I cat desc:
------------------------------------------------------------------------
mysystem:/sys/devices/system/cpu/cpu0/cpuidle/state0/# cat desc
CPUIDLE CORE POLL IDLE
------------------------------------------------------------------------

Here is my question:What the meaning of  ‘CPUIDLE CORE POLL IDLE'?

Any help will be appreciated!
--
Sincerely,
Ren Zhen
