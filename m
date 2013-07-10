Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3GJLeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:34:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GJLeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:34:12 -0400
Message-ID: <51DD46AD.2010800@canonical.com>
Date: Wed, 10 Jul 2013 13:34:05 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: Matt Fleming <matt.fleming@intel.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [REGRESSION] "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"
 breaks macbook efi boot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
letting my macbook pro boot succesfully.

Is there anything I can do to help diagnose this issue?

~Maarten

