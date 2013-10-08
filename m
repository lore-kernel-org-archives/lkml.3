Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3JHKAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:00:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48960 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3JHKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:00:30 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-1a-5253d7bcaeb5
Message-id: <5253D7BB.3020701@samsung.com>
Date: Tue, 08 Oct 2013 12:00:27 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801
 Thunderbird/17.0.8
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vb2: Allow STREAMOFF for io emulator
References: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
 <5253B2BE.5090209@samsung.com>
 <CAPybu_0-b2BfuTVd09B4dreFHCsYSg=SjjrDCHXKrqNGzFSX2w@mail.gmail.com>
In-reply-to: <CAPybu_0-b2BfuTVd09B4dreFHCsYSg=SjjrDCHXKrqNGzFSX2w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xy7p7rgcHGTw8zmtxtukNu8XlXXPY
	LHo2bGW1uLhO3mLK25/sFl3d85gc2Dx2zrrL7vH410s2j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo48notS8FVlordkzqYGxhvMXcxcnJICJhInLrwhRXCFpO4cG89WxcjF4eQwFJGiRt/
	r7KDJIQEPjFKrNhu0sXIwcEroCVxcYEzSJhFQFVi24fpYCVsAoYSXW+72EBsUYFQiZ5L28Fs
	XgFBiR+T77GA2CIC5hKXP3SCxZkFLjBK7N+mDmILC1hKrPg4A2rvRkaJXzdWM4EkOAWCJXb9
	WscK0WAm8ahlHTOELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz
	0vWS83M3MULC+csOxsXHrA4xCnAwKvHwChwOChJiTSwrrsw9xCjBwawkwrvmanCQEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBkbxrVsvL/fsk5MJUMtM++t+6vjFCnGZ3ru7Tk6VqQl2WnJt+bG2
	rDKNNomWWQv+ZZ7WulV8ym9DrsTJ7TIyx/5vSvPW3O9edjSaT2pRhFa+hUnNywV5CjE+xeqC
	n35YJCbUlsU9UJplItd0+L/H4/agi9lJpcHmvf9Te35M9Wba25C/ZcefOUosxRmJhlrMRcWJ
	AOknHSVFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Racardo,

On 2013-10-08 09:58, Ricardo Ribalda Delgado wrote:
> Hi Marek
>
> Thanks for your comments. I was just trying to find a way to stop
> streaming while in read/write mode without having to close the
> descriptor. I thought reusing streamoff was more clever than creating
> a new ioctl.

Read()/write() mode is mainly designed for old and legacy applications. 
Those applications assume that the only reliable way to stop streaming 
is to close the fd. New tools should use libv4l and ioctl-based api.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

