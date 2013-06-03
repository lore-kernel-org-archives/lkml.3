Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3FCM1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:27:05 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:57496 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564Ab3FCM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:27:02 -0400
Message-ID: <51AC8B9D.1060702@calxeda.com>
Date: Mon, 03 Jun 2013 07:27:09 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "timur@tabi.org" <timur@tabi.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "clemens@ladisch.de" <clemens@ladisch.de>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3] ata: increase retry count but shorten duration for
 Calxeda controller
References: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com> <1370014046-5202-1-git-send-email-mark.langsdorf@calxeda.com> <20130602080010.GB8286@mtj.dyndns.org>
In-Reply-To: <20130602080010.GB8286@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 03:00 AM, Tejun Heo wrote:
> On Fri, May 31, 2013 at 10:27:26AM -0500, Mark Langsdorf wrote:
> 
> For the third time, explain the above in the comment; otherwise, it's
> not going in.

Sorry, I completely misread your requirement. I'll move it to the
comment as requested.

--Mark Langsdorf
Calxeda, Inc.

