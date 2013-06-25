Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3FYDPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:15:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31345 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYDPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:15:06 -0400
X-Spam-Score: -100.8
Message-ID: <51C90B06.5070802@asianux.com>
Date: Tue, 25 Jun 2013 11:14:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [Suggestion] arch: avr32: compiler: compiling tools issue
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

With allmodconfig, and set "avr32-linux-gnu-" as cross compiler prefix.

It will report error:
  avr32-linux-gnu-gcc: error: unrecognized command line option ‘-mno-pic’
  avr32-linux-gnu-gcc: error: unrecognized command line option ‘-march=ap’

The related gcc version:
  [root@dhcp122 linux-next]# rpm -qf /usr/bin/avr32-linux-gnu-gcc
  gcc-avr32-linux-gnu-4.7.1-0.1.20120606.fc17.x86_64

Can we say: it is compiler's issue, and I need try to compile the cross
compiler to test it again ?

Welcome any additional suggestion or completions.

Thanks.
--
Chen Gang

Asianux Corporation 
