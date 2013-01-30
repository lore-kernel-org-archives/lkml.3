Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3A3M0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:26:38 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:55119 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3A3M0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:26:21 -0500
Message-ID: <51091159.5080304@mvista.com>
Date: Wed, 30 Jan 2013 16:26:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Youquan Song <youquan.song@intel.com>
CC: htejun@gmail.com, ming.lei@canonical.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com, jlee@suse.com,
        james.d.ralston@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] ata: Fix DVD not dectected at some Haswell platforms
References: <1359566374-27286-1-git-send-email-youquan.song@intel.com>
In-Reply-To: <1359566374-27286-1-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-01-2013 21:19, Youquan Song wrote:

> There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d

   Please also specify the summary of that patch in parens.

> fix the 4 ports

    s/fix/fixing/

> IDE controller 32bit PIO mode.
> Recently, the problem was showed

    s/showed/shown/

> at Haswell platform which includes 2 ports IDE controller.

> So introduce a qurik

    Quirk.

> patch to disable 32bit PIO at this IDE controller.

    s/at/on/

> Signed-off-by: Youquan Song <youquan.song@intel.com>

MBR, Sergei

