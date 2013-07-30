Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3G3EDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:03:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3G3EDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:03:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,775,1367942400"; 
   d="scan'208";a="8064337"
Message-ID: <51F73B56.1040401@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 12:04:38 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: dwight.engen@oracle.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
 projids in any user namespace
References: <87txpaph4n.fsf@xmission.com> <1361149870-27732-1-git-send-email-ebiederm@xmission.com> <1361149870-27732-5-git-send-email-ebiederm@xmission.com> <20130219015550.GJ26694@dastard> <51F616F2.5040906@cn.fujitsu.com> <20130729075109.GF13468@dastard> <51F72FE6.4080202@cn.fujitsu.com> <20130730035748.GJ21982@dastard>
In-Reply-To: <20130730035748.GJ21982@dastard>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 12:01:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 12:01:04,
	Serialize complete at 2013/07/30 12:01:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:57 AM, Dave Chinner wrote:
> On Tue, Jul 30, 2013 at 11:15:50AM +0800, Gao feng wrote:
>> On 07/29/2013 03:51 PM, Dave Chinner wrote:
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028467.html
>>>
>>> Basically, the discussion we are currently having is whether project
>>> IDs should be exposed to user namespaces at all. e.g:
>>>
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028497.html
>>> http://oss.sgi.com/pipermail/xfs/2013-July/028551.html
>>>
>>> "Basically, until we have worked out *if* project quotas can be used
>>> safely within user namespaces, we need to reject any attempt to use
>>> them from within a user namespace container."
>>>
>>
>> yes, seems this v6 patchset allows user in un-init user namespace to setup proj quota
>> through ioctl, and the projid hasn't been converted to kprojid in this patchset.
>> Doesn't this will cause user in container has the ability to change the proj quota
>> which is set by root user in host?
> 
> Dwight just posted v7. can you discuss your concerns in reposnse to
> the relevant patch in that series, please? it's much easier for
> everyone if we keep the discussion int eh one thread ;)
> 

sure, I am compiling  v7 patchset now in order to confirm my misgiving :)

Thanks
