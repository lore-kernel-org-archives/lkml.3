Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3JJIo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:44:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53385 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3JJIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:44:52 -0400
Message-ID: <525668F9.60509@gmail.com>
Date: Thu, 10 Oct 2013 14:14:41 +0530
From: Prashant Shah <pshah.me@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: copy of write for disk blocks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is it feasible to add support for copy of write for disk blocks within 
the block layer itself ? Setting a flag in the struct bio will cause the 
block layer to copy the original data before over writing it.

Regards.
