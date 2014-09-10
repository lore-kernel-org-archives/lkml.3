Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaIJDiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:38:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45875 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaIJDiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:38:52 -0400
Message-ID: <540FC7C8.1070904@gmail.com>
Date: Tue, 09 Sep 2014 21:38:48 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ide
To: Ming Lei <ming.lei@canonical.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gaurav <gspatel@hp.com>
Subject: Re: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata controller
References: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
In-Reply-To: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 02:22 AM, Ming Lei wrote:
> Hi Guys,
>
> When we use hdparm to download firmware on system with
> Marvell 88SE9125 SATA controller, it returns failure always
> and it has been observed in several systems:
>
> #hdparm --fwdownload-mode7 fw.bin
> --yes-i-kno-what-i-am-doing --please-destroy-my-drive /dev/sda
>
> /dev/sda:
> fwdownload: xfer_mode=7 min=1 max=65535 size=699392
> FAILED: Input/output error

Any errors in dmesg after doing this?

