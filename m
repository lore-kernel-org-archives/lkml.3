Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJSRc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:32:29 -0400
Received: from smtp-3.concepts.nl ([213.197.30.127]:44707 "EHLO
	smtp-3.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaJSRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:32:25 -0400
Message-ID: <5443F5A1.1050004@xmsnet.nl>
Date: Sun, 19 Oct 2014 19:32:17 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Subject: Re: 3.17.0+ files disappearing after playing old dos game on nfsroot
 laptop
References: <543ED24D.4070905@xmsnet.nl>
In-Reply-To: <543ED24D.4070905@xmsnet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1XfuL4-0004MB-9Y
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: jmdebruin@xmsnet.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 10:00 PM, Hans de Bruin wrote:
> After playing an old dos game i am missing files on my nfsroot installed
> laptop. Which one, wel /bin/ls is at least one of them. After a reboot
> there all back again.  But not al is well. Some icons on my kde panel
> where gone. I have seen this twice in the last day's
>

The problem appears immediately after starting dosemu so this bisectable

-- 
Hans

