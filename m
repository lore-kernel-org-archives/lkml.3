Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3EHUcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:32:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:36939 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3EHUcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:32:07 -0400
Message-ID: <518AB646.1000406@candelatech.com>
Date: Wed, 08 May 2013 13:32:06 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: relayfs question related to removing parent directory.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a crash when unloading the ath9k module.

It seems relay_close() is being passed bad memory.

The relay_open call uses an ath9k debugfs directory, so
that may be removed before the call to relay_close()
is called.

Does relayfs automatically close files when the parent
directory is removed?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

