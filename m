Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966196Ab3HHTJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:09:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:52886 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966146Ab3HHTJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:09:06 -0400
Message-ID: <5203ED45.3090604@gmx.net>
Date: Thu, 08 Aug 2013 21:11:01 +0200
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: dsterba@suse.cz, Sergei Trofimovich <slyich@gmail.com>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
References: <1375911803-17318-1-git-send-email-slyich@gmail.com> <1375911803-17318-7-git-send-email-slyich@gmail.com> <520349BA.8080006@gmx.net> <20130808132614.GS5284@twin.jikos.cz> <20130808174657.GV12314@lenny.home.zabbo.net>
In-Reply-To: <20130808174657.GV12314@lenny.home.zabbo.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:gHXcVfx8xqOmxahZ1I9luQOCrVuCrPP/DwnhPKoJZ1mPmvgyLJn
 XRUxsjNKJVLL7VzFwRB8A4OBsHm+hgvDKv1UfWHTGiDOxHMhrW6q6SHkWxiq4LWHq5zoczJ
 Dk7ap3LrvwN1G722mxM9+gIkvhLkg5ad3O1nnGpCVVJ4ZJLdg3TXlv6HtqgfEMhdrZSbwBM
 y/9fu743UdoXvecyh4sDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/13 19:46, Zach Brown wrote:
>>> even though the function is currently unused, I'm hesitating to remove it
>>> as it's part of the reada-API and might be handy for anyone going to use
>>> the API in the future.
>>
>> I agree. As replied here,
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html
>> please keep the function.
> 
> If we're keeping score, put me down for being in favour of removing dead
> untested code.  git ressurection is easy. 

It's not really untested, it has been in use some time ago. But of
course there's a chance that some changes broke it.
Yes, git ressurection is easy. To inform potential users, you might
just leave a comment like this:

/*
 * There has been a function once to detach from a running reada.
 * If you need such functionality, just revert the commit that
 * added this comment.
 */

-Arne

> 
> - z
> 

