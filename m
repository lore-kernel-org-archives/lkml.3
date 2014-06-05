Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaFEHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:10:49 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:48604 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEHKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:10:47 -0400
Message-ID: <539017F0.1080503@acm.org>
Date: Thu, 05 Jun 2014 09:10:40 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c:  Optimization of the Code
References: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <5390147F.8070803@acm.org>
In-Reply-To: <5390147F.8070803@acm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/14 08:55, Bart Van Assche wrote:
> On 06/04/14 20:08, Rickard Strandqvist wrote:
> This is ugly. Please use sprintf(buf, "%.*s\n", PAGE_SIZE - 1, str)
> instead of strncpy() + strlen().

(replying to my own e-mail)

The above should of course have read "sprintf(buf, "%.*s\n", PAGE_SIZE -
2, str)" to avoid that the terminating '\0' triggers a buffer overflow.

Bart.
