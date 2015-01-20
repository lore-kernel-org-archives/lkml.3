Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750768AbbATFSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:18:49 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60543 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbATFSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:18:48 -0500
MIME-Version: 1.0
From: Divya Vyas <edivya.vyas@gmail.com>
Date: Tue, 20 Jan 2015 10:48:27 +0530
Message-ID: <CAGfiMvCpDs90=+baZS8a9dw=B6XX2H9=tO9=zRtTz2uxB+kx0A@mail.gmail.com>
Subject: PERF CTF traces profile view
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I have converted the perf.data file into CTF format .

I have imported the CTF traces into eclipse as generic CTF traces and
I am seeing the control flow, resource flow  etc. in LTTng kernel
perspective . I am not seeing anything in perf profile view ( Show
view -> profiling  -> perf profile view) , perf source disassembly
etc.

Is there any way to see all these information ?

Thanks,
Divya Vyas
