Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaGQN6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:58:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43741 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbaGQN6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <53C7D52E.5020205@imgtec.com>
References: <1405603655-12571-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<53C7D52E.5020205@imgtec.com>
Date: Thu, 17 Jul 2014 16:58:35 +0300
Message-ID: <CANZNk81DOOxYYFSKZMCh=uABd3ONB8wToTFc3_L_9TfyQDS1yQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] arch/mips/net/bpf_jit.c: fix failure check
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        dborkman@redhat.com, ralf@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-17 16:52 GMT+03:00 Markos Chandras <Markos.Chandras@imgtec.com>:
> Thanks for the patch. I would personally prefer to use a new signed int
> variable, but I am fine either way.

If that's not a problem for performance etc., then i'll resubmit with
new temporary signed variable, because i believe it would be simpler
to comprehend.

-- 
Andrey Utkin
