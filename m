Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaGGV04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaGGV0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:26:55 -0400
Message-ID: <53BB1098.3070501@redhat.com>
Date: Mon, 07 Jul 2014 14:26:48 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: target-devel@vger.kernel.org
CC: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org,
        shli@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] target: userspace pass-through backend
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here's some additional beginning bits for the configuration and use 
of this code:

Changes to targetcli-fb and rtslib-fb:

https://github.com/agrover/targetcli-fb/tree/userback
https://github.com/agrover/rtslib-fb/tree/userback

An incredibly-crappy stand-in for the user process that will handle 
requests:

https://github.com/agrover/test-userback

I look forward to your feedback :)

Thanks -- Regards -- Andy

p.s. kernel changes are also available here:
https://github.com/agrover/linux/tree/userback
