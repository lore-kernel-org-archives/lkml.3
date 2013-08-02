Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3HBXCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:02:30 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:44296 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262Ab3HBXC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:02:28 -0400
Message-ID: <51FC3A7F.3080806@hurleysoftware.com>
Date: Fri, 02 Aug 2013 19:02:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Only hangup once
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com> <20130802034647.GA28611@kroah.com>
In-Reply-To: <20130802034647.GA28611@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 11:46 PM, Greg Kroah-Hartman wrote:
> A diff inside the changelog entry of a diff is going to cause havoc :)

Right, sorry :)  Won't happen again.

> I'll go edit this to make it not complain...

Thanks,
Peter Hurley
