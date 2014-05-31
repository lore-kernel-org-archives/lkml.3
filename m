Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaEaVYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:24:16 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:39165 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaEaVYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:24:15 -0400
Message-ID: <538A4888.1040204@cogentembedded.com>
Date: Sun, 01 Jun 2014 01:24:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] USB: kl5kusb105: Remove useless return variables
References: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>	<538A46DF.1040009@cogentembedded.com> <CA+MoWDqDqwOSirh+aP72t_t_2KNajmfn8v5ywpAuLsjJssBwxw@mail.gmail.com>
In-Reply-To: <CA+MoWDqDqwOSirh+aP72t_t_2KNajmfn8v5ywpAuLsjJssBwxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/01/2014 01:21 AM, Peter Senna Tschudin wrote:

>>> This patch remove variables that are initialized with a constant,
>>> are never updated, and are only used as parameter of return.
>>> Return the constant instead of using a variable.

>>    The patch does more than just that, it also removes commented out code.

> That was my fault. It was fixed on V2:
> http://marc.info/?l=kernel-janitors&m=140155221232137&w=2

    Yes, I forgot to look at the follow-ups before replying.

WBR, Sergei

