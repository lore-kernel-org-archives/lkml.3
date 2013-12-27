Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3L0M0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:26:24 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62594 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3L0M0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:26:21 -0500
Message-ID: <52BD71D7.9060709@landley.net>
Date: Fri, 27 Dec 2013 06:25:59 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: Re: What does echo -c do (as found in dynamic-debug-howto.txt)
References: <52BC698A.9030805@ahsoftware.de>
In-Reply-To: <52BC698A.9030805@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13 11:38, Alexander Holler wrote:
> Hello,
>
> I've just read Documentation/dynamic-debug-howto.txt (again) and I
> wonder what the parameter -c for echo is for (found at lines 94 ff).
>
> Neither echo from coreutils nor the buildin from bash do know the
> parameter -c.

Huh. No idea.

Annotate points at Jason Baron, whom you've cc'd...

Rob

> Is that -c a parameter for a buildin echo of one of the various shells,
> a typo (looks unlikely) or do I miss something else which make me look a
> noob?

I've implemented echo for toybox, it has -n and -e support. "man echo" 
shows -neE (and -E is one of those pointless gnuisms that doesn't 
actualy do anything). man bash shows the echo builtin also has -neE.

No -c anywhere to be found, it's not just you...

Rob
