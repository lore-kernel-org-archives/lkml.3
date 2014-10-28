Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaJ1Oie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:38:34 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:30783 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaJ1Oic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:38:32 -0400
Message-ID: <544FAA65.90904@imgtec.com>
Date: Tue, 28 Oct 2014 14:38:29 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 09/11] drivers: char: axd: add sysfs setup files
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com> <1414495589-8579-10-git-send-email-qais.yousef@imgtec.com> <20141028141154.GB18384@kroah.com>
In-Reply-To: <20141028141154.GB18384@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 02:11 PM, Greg Kroah-Hartman wrote:
> On Tue, Oct 28, 2014 at 11:26:27AM +0000, Qais Yousef wrote:
>> lots of AXD configuration is exposed through sysfs, these
>> files create all the necessary nodes to allow setting up AXD
> Yet you don't document that interface through the required
> Documentation/ABI/ files?  Why not?
>
Sorry I didn't realise I need to do that. I'll fix that in the next series.

Thanks,
Qais
